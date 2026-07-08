from dotenv import load_dotenv
import subprocess
import sys 

load_dotenv()

if len(sys.argv) < 3:
    print("nombre des paramètres insuffissants")
    sys.exit(1)

commande = sys.argv[1:]

commande.extend(["--profiles-dir", "."])

subprocess.run(commande, check=True)