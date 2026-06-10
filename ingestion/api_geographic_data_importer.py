import pandas as pd
from sqlalchemy import create_engine
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
                print("connection réussite")
        except Exception as e :
            print(f"error: {e} ")

    def load_geo_department_data(self):
        try: 
            api_res = re.get(self.URL)
            self.df = pd.DataFrame(api_res.json())
         
        except Exception as e:
            print(f"error : {e}")