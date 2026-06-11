import sys
import api_data_importer as adi
import api_geographic_data_importer as agdi

def main () -> int :
	
    data_import = adi.api_data_importer()
    data_import.connexion()
    data_import.data_loader()
    data_import.save_data_DB()
    data_import.clear_data()
    
    geo_data = agdi.api_geographic_data_importer()
    geo_data.connexion()
    geo_data.load_geo_department_data()
    geo_data.save_geo_depart()
    geo_data.load_geo_communes()

    return 0

if __name__ =='__main__':
	sys.exit(main())
