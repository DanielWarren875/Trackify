import firebase_admin
from firebase_admin import firestore
from firebase_admin import credentials
from firebase_admin import firestore
cred = credentials.Certificate()
app = firebase_admin.initialize_app(cred)
db = firestore.client()


ref = db.collection('Tracks').select(field_paths=[]).get()
ids = [item.id for item in ref]

for i in ids:
	try:
		doc = db.collection('Tracks').document(i).get().to_dict()
		hold = {
			'trackId': doc['trackId'],
			'trackName': doc['trackName'],
			'albumImage': doc['albumImage'],
			'duration': doc['duration'],
			'trackPopularity': doc['trackPopularity'],
			'artistNames': doc['artistName']
		}
		doc = db.collection('Tracks').document(i).delete()
		doc = db.collection('Tracks').document(i).set(hold)
	except:
		print(i)