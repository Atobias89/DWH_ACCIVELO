import sys
import api_data_importer as adi

def main () -> int :
	data_import = adi.api_data_importer()
	data_import.connexion()
	data_import.data_loader()
	data_import.save_data_DB()
	data_import.clear_data()

if __name__ =='__main__':
	sys.exit(main())