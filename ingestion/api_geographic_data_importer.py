import pandas as pd
from sqlalchemy import create_engine, text
import psycopg2
from dotenv import load_dotenv
import os
import requests as re
class api_geographic_data_importer:
    def __init__(self):
        self.URL = "https://geo.api.gouv.fr/departements"

        load_dotenv()
        
        self.host = os.getenv("DB_HOST")
        self.password = os.getenv("DB_PASS")
        self.port = os.getenv("DB_PORT")
        self.bdd = os.getenv("DB_BDD")
        self.user = os.getenv("DB_USER")
        self.schema = os.getenv("DB_SCHEMA")
        
        self.engine = None
        self.df = None
    
    def connexion(self):
        try :
            post_con = f"postgresql+psycopg2://{self.user}:{self.password}@{self.host}:{self.port}/{self.bdd}?options=-csearch_path={self.schema}"
            self.engine = create_engine(post_con)
            with self.engine.connect() as con :
                result = con.execute(text("SELECT version()"))
                version = result.fetchone()[0] 
                print(f"connection réussite :{version} ")
        except Exception as e :
            print(f"error: {e} ")

    def load_geo_department_data(self):
        try: 
            api_res = re.get(self.URL)
            self.df = pd.DataFrame(api_res.json())
            print("Data loaded succesfully...")
        except Exception as e:
            print(f"error : {e}")
    
    def save_geo_depart(self):
  
        try:
            if  self.df is None :
                print("No data stored")
                return
           
                        # Vérifier après sauvegarde
            count = 0            
            with self.engine.connect() as connection:
                query = text(f'SELECT COUNT(*) FROM "{self.schema}".info_geo_departments')
                count = connection.execute(query).scalar()
                print(f"save_geo_depart -> Vérification : {count} lignes en base")
               
        
           

            if self.engine is not None and len(self.df) > count:
                self.df.to_sql("info_geo_departments", 
                               con=self.engine ,
                               schema = self.schema, 
                               if_exists="replace",
                               index=False)
                print("Data saved succesfully in Db...")
            else:    
                print("Nombre de departements inchangé")
        except Exception as e:
            print(f"error: {e}")
    
    def load_geo_communes(self):
        try: 
            if self.df is None : 
                print("No data store")
                return    
            df_communes = pd.DataFrame()
            for values in self.df['code']:                              
                API_RES = re.get(self.URL+"/"+values+"/communes")                 
                df_communes = pd.concat([df_communes  ,pd.DataFrame(API_RES.json())],ignore_index=True) 

            df_communes.to_sql("info_geo_communes", self.engine, schema=self.schema, if_exists="replace", index=False)           
            print("informations des communes sauvegardés")

              
        except Exception as e : 
            print(f"Error : {e}")
