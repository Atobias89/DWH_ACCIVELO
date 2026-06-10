import requests
import pandas as pd
from sqlalchemy import create_engine
import os
from dotenv import load_dotenv
import time


class api_data_importer:
	def __init__(self):
		load_dotenv()
		self.URL = "https://opendata.koumoul.com/data-fair/api/v1/datasets/accidents-velos/lines"

		self.dbname = os.getenv('DB_BDD')
		self.user = os.getenv('DB_USER')
		self.host = os.getenv('DB_HOST')
		self.port = os.getenv('DB_PORT')
		self.password = os.getenv('DB_PASS')
		self.schema = os.getenv('DB_SCHEMA')

		self.engine = None
		self.all_data = []
	
	def connexion(self):
		print("conecting to DB")
		try:
			connexion = f"postgresql+psycopg2://{self.user}:{self.password}@{self.host}/{self.dbname}?options=-csearch_path={self.schema}"
			self.engine = create_engine(connexion)
			with self.engine.connect() as con :
				print("connexion réussite")
		except Exception as e: 
			print(f"error : {e}")
	
	def data_loader(self):
		print("loading data....")
		try:
			pagenum = 0
			
			while self.URL and pagenum < 2:
			
				response  = requests.get(self.URL)
				api_res = response.json()
				
				self.all_data.extend(api_res.get('results'))
				
				self.URL = api_res.get('next')
				time.sleep(0.5)
				
				pagenum += 1
			

		except Exception as e :
			print(f"Error : {e}")

	def save_data_DB(self):
			print("saving data.....")
			try : 
				if not self.all_data:
					print("Not data loaded from the Api")
					return
				
				df = pd.json_normalize(self.all_data)
				#---creation de la table localisation_accident
				colonnes_loc_acc = ['Num_Acc','dep','com','lat','long']
				df[colonnes_loc_acc].to_sql("localisation_accident",self.engine,schema= self.schema ,if_exists='append',index=False )
					
				#--- creation de la table accident info
				colonnes_accident_info = ['Num_Acc','int','col','lum','atm','catr','circ','nbv','prof','plan','lartpc','larrout','surf','infra','situ','obs','obsm','choc','agg','date']
				df[colonnes_accident_info].to_sql("information_accident", self.engine,schema=self.schema,if_exists="replace",index=False)
					
				#---- creation table information victime
				colonnes_info_vic = ['Num_Acc','grav','sexe','age','trajet','equipement']
				df[colonnes_info_vic].to_sql("information_victime", self.engine,schema=self.schema,if_exists="append",index=False)

				# information de vehicule
				colonnes_inf_vehicule = ['Num_Acc','manv','vehiculeid','typevehicules','manoeuvehicules','numVehicules','_infos_commune.code_epci']
				df[colonnes_inf_vehicule].to_sql("information_vehicule",self.engine, schema=self.schema, if_exists="append", index=False)
			except Exception as e: 
				print(f"eror  : {e}")
	
	def clear_data(self):
		print("Ereasing Data...")
		self.all_data = []
	
