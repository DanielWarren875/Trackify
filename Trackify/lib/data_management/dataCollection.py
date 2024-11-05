import base64
import datetime
import json
import os
import random
import string
from time import sleep
from datetime import datetime, timedelta, timezone
import webbrowser
import requests
import firebase_admin
from firebase_admin import firestore
from firebase_admin import credentials
from firebase_admin import firestore
import mysql.connector

class collectData():
	def __init__(self):
		global db
		global app
		cred = credentials.Certificate('/Users/danielwarren/Desktop/statsproj-589e7-firebase-adminsdk-3i4ip-a047e0caae.json')
		app = firebase_admin.initialize_app(cred)
		db = firestore.client()
		
	def auth(self):
			global c
			global redirect
			c = 'bf9fd0131e0a4c56ab5ec69dc87befc3'
			redirect = 'http://localhost:80'
			chars = string.ascii_lowercase + string.digits
			state = ''.join(random.choice(chars) for i in range(16))
			scope = 'user-read-playback-state,user-read-email,user-read-private'
			type = 'code'
			url = f'http://accounts.spotify.com/authorize?response_type={type}'
			url = url + f'&client_id={c}&scope={scope}'
			url = url + f'&redirect_uri={redirect}&state={state}'
			webbrowser.open(url)
			
	def decodeAuthData(self, authData):
		grantType = 'authorization_code'
		code = authData[authData.find('code=') + 5: authData.find('&state')]
		s = '9ab7c1a94f2841d6bb97102680edd97d'
		data = {
			'grant_type': grantType,
			'code': code,
			'redirect_uri': redirect
		}
		encode = base64.urlsafe_b64encode((c + ':' + s).encode())
		header = {
			'Authorization': 'Basic %s' %encode.decode('ascii'),
			'Content-Type': 'application/x-www-form-urlencoded'
		}
		url = 'https://accounts.spotify.com/api/token'
		r = requests.post(url=url, headers=header, data=data)
		
		x = json.loads(r.text)
		return {
			'access_token': x['access_token'],
			'token_type': x['token_type'],
			'expires_in': x['expires_in'],
			'refresh_token': x['refresh_token'],
			'scope': x['scope']
		}
	
	def refreshToken(self, authData):
			c = 'bf9fd0131e0a4c56ab5ec69dc87befc3'
			s = '9ab7c1a94f2841d6bb97102680edd97d'
			data = {
				'grant_type': 'refresh_token',
				'refresh_token': authData['refresh_token'],
			}
			print(data)
			encode = base64.urlsafe_b64encode((c + ':' + s).encode())
			headers = {
				'Content-Type': 'application/x-www-form-urlencoded',
				'Authorization': 'Basic %s' %encode.decode('ascii')
			}
			url = 'https://accounts.spotify.com/api/token'
			r = requests.post(url=url, headers=headers, data=data)
			print(r.text)
			x = json.loads(r.text)
			
			return{
				'access_token': x['access_token'],
				'token_type': x['token_type'],
				'expires_in': x['expires_in'],
				'refresh_token': authData['refresh_token'],
				'scope': x['scope']
			}
	
	def getPlaybackState(self, authData):
		url = 'https://api.spotify.com/v1/me/player'
		header = {
			'Authorization': f'Bearer ' + authData['access_token']
		}
		try:
			r = requests.get(url=url, headers=header)
			if r.text == '':
				return 'Null'
			else:
				x = json.loads(r.text)
				item = x['item']
				
				playing = x['is_playing']
				albumImage = item['album']['images'][0]['url']
				trackName = item['name']
				trackId = item['id']
				trackPopularity = item['popularity']
				
				artists = item['artists']
				artIds = []
				for i in artists:
					artIds.append(i['id'])
				
				dur = item['duration_ms']
				progress = x['progress_ms']
				
				timeLeft = (dur - progress) / 1000
				
				trackData = {
					'trackId': trackId,
					'trackName': trackName,
					'trackPopularity': trackPopularity,
					'albumImage': albumImage,
					'artistIds': artIds,
					'duration': dur / 1000
				}
				
				return {
					'isPlaying': playing,
					'timeLeft': timeLeft,
					'data': trackData
				}
		except:
			print(r.text)
			return
	def addToFirestore(self, data):
		time = str(datetime.now(timezone.utc).isoformat())
		time = time[:-9] + 'Z'
		for i in data['artistIds']:
			hold = self.getArtistsData(i)
			self.addArtistToFirestore(hold)
		trackRef = db.collection('Tracks').document(data['trackId'])
		trackRef.set(data)
		ref = db.collection('Users').document(displayName)
		ref.update({
			'listenData': firestore.ArrayUnion([{time: trackRef}])}
		)
	
	def getArtistsData(self, artistId):
		url = f'https://api.spotify.com/v1/artists/{artistId}'	
		header = {
			'Authorization': f'Bearer ' + authData['access_token']
		}
		r = requests.get(url=url, headers=header)
		x = json.loads(r.text)
		return {
			'id': x['id'],
			'name': x['name'],
			'popularity': x['popularity'],
			'imageUrl': x['images'][0]['url'],
			'genres': x['genres']
		}
	def addArtistToFirestore(self, artistData):
		ref = db.collection('Artists').document(artistData['id'])
		ref.set(artistData)
		
		return ref
		
		
	def getDisplayName(self, authData):
		url = 'https://api.spotify.com/v1/me'
		header = {
			'Authorization': f'Bearer ' + authData['access_token']
		}
		
		r = requests.get(url=url, headers=header)
		x = json.loads(r.text)
		return x['display_name']
	
	def addUserDataToFirestore(self, authData, displayName):
		db.collection('Users').document(displayName).set(authData)
		
	def getUserDataFromFirestore(self, displayName):
		return db.collection('Users').document(displayName).get().to_dict()
	
	def checkIds(self, displayName):
		ref = db.collection('Users').select(field_paths=[]).get()
		ids = [item.id for item in ref]
		
		if displayName not in ids:
			return False
		else:
			return True
	def addUserToSpotStats(self, accTok, expires, refTok, scope, tokType):
		try:
			addUser = ("INSERT INTO users "
        	       "(userId, accessTok, expires, refreshTok, scope, tokType) "
        	       "VALUES (%s, %s, %s, %s, %s, %s)")
			dataUser = (displayName, accTok, expires, refTok, scope, tokType)
			
			cur.execute(addUser, dataUser)
			con.commit()
		except:
			return
	def addTrackToSpotStats(self, data):
		try:
			addTrack = ("Insert ignore into tracks "
			   			"(trackId, artistId, duration, trackName, trackPopularity, albumImageUrl) "
						"values (%s, %s, %s, %s, %s, %s)")
			for j in data['artistIds']:
				trackData = (data['trackId'], j, data['duration'], data['trackName'], data['trackPopularity'], data['albumImage'])
				cur.execute(addTrack, trackData)
				
			con.commit()
		except:
			return
	def addArtistToSpotStats(self, artistId):
		artistData = self.getArtistsData(artistId)
		addArtist = ("insert ignore into artists "
				"(artistId, artistName, imageUrl, genre, popularity) "
				"values (%s, %s, %s, %s, %s)")
		artistData = (artistData['id'], artistData['name'], artistData['imageUrl'], str(artistData['genres']), artistData['popularity'])
		cur.execute(addArtist, artistData)
		
		con.commit()
		
	def addListenData(self, userId, trackId):
		try:
			addData = ("insert into listenData "
			  "(userId, dateListened, trackId) "
			  "values (%s, %s, %s)")
			data = (userId, datetime.now(), trackId)
			cur.execute(addData, data)
			con.commit()
		except:
			return
	
		
		
a = collectData()

a.auth()
authData = a.decodeAuthData(input('Input Code Here'))
global displayName
displayName = a.getDisplayName(authData)
global con
global cur
con = mysql.connector.connect(user='root', password='root', host='localhost', port=8889, database='SpotifyStats')
cur = con.cursor()
a.addUserToSpotStats(authData['access_token'], authData['expires_in'], authData['refresh_token'], authData['scope'], authData['token_type'])
currentlyPlaying = a.getPlaybackState(authData)

while True:
	try:
		hold = a.getPlaybackState(authData)
		if currentlyPlaying == 'Null':
			sleep(10)
		else:
			if not currentlyPlaying['isPlaying']:
				sleep(10)
			else:
				
				if hold['data']['trackName'] != currentlyPlaying['data']['trackName']:
					currentlyPlaying = hold
				else:
					if hold['timeLeft'] / hold['data']['duration'] <= .5:
						a.addTrackToSpotStats(currentlyPlaying['data'])

						for i in hold['data']['artistIds']:
							a.addArtistToSpotStats(i)
						a.addListenData(displayName, currentlyPlaying['data']['trackId'])
						while True:
							currentlyPlaying = hold
							hold = a.getPlaybackState(authData)
							if hold == 'Null':
								break
							elif not hold['isPlaying']:
								break
							elif hold['data']['trackName'] != currentlyPlaying['data']['trackName']:
								break
							else:
								sleep(10)
					else:
						try:
							timeSleep = hold['data']['duration'] * .05
							sleep(timeSleep)
						except:
							print(hold)
		currentlyPlaying = hold
	except:				
		authData = a.refreshToken(a.getUserDataFromFirestore(displayName))

