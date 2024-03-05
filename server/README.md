# Partie serveur

## Documentation Docker

Pour creer la BDD SQL, il faut utiliser un docker pour ce faire suivre les étapes suivantes :

1. Création d'un fichier docker-compose.yml à la racine du dossier server :

```yml
version: '3'
services:
  app:
    build:
      context: .
      dockerfile: Dockerfile
    ports:
      - "3000:3000"
    volumes:
      - ./app:/app
    environment:
      - FIREBASE_CREDENTIALS=./credentials/firebaseAdminCredentials.json
    depends_on:
      - mysql

  mysql:
    image: mysql:latest
    environment:
      MYSQL_ROOT_PASSWORD: process.env.BDDpsw
      MYSQL_DATABASE: process.env.BDDdatabase

```

2. Création du fichier Dockerfile à la racine du dossier server :

```Dockerfile
FROM node:14

WORKDIR /app

COPY package*.json ./

RUN npm install

COPY . .

EXPOSE 3000

CMD ["node", "app.js"]
```

3. Création d'un fichier .dockerignore, il faut mettre les éléments suivants à l'intérieur de celui-ci :

```.dockerignore
npm-debug.log
/node_modules
```

4. Création du docker via le terminal

```
docker run --name Docker-mysql -e MYSQL_ROOT_PASSWORD=MyLuckyluck6*ql -d mysql:latest

docker exec -it Docker-mysql bash

------------------------------------------------------------------------------------------
// Sans automatisation

docker build -t docker_sco2 .

docker run -p 3000:3000 docker_sco2

------------------------------------------------------------------------------------------
// Avec automatisation (server automatisé)

docker-compose up --build

docker-compose down

```

## Documentation BDD SQL

1. Installation de mysql

```
apt-get install mysql
```

2. Lancement de mysql

```
mysql -u root -p
```

3. Création des tables

```sql
CREATE TABLE users(
  userID varchar(255) PRIMARY KEY NOT NULL, 
  score int
);

CREATE TABLE notifications(
  notificationID int PRIMARY KEY AUTO_INCREMENT, 
  userID varchar(255) NOT NULL, 
  notificationContent varchar(255), 
  notificationTitle varchar(255), 
  notificationStatus varchar(255)
);

CREATE TABLE activities(
  activityID int PRIMARY KEY AUTO_INCREMENT, 
  userID varchar(255) NOT NULL, 
  activityType varchar(255),
  activityCO2Impact float, 
  activityPollutionImpact float, 
  activityName varchar(255), 
  activityTimestamp CURRENT_TIMESTAMP
);

CREATE TABLE recurrentActivities(
  recurrentActivityID int PRIMARY KEY AUTO_INCREMENT, 
  userID varchar(255) NOT NULL, 
  recurrentActivityType varchar(255), 
  recurrentActivityCO2Impact float, 
  recurentActivityPollutionImpact float, 
  activityName varchar(255), 
  activityTimestamp CURRENT_TIMESTAMP
);

CREATE TABLE friends(
  friendshipID int PRIMARY KEY AUTO_INCREMENT, 
  userID1 varchar(255), 
  userID2 varchar(255), 
  friendshipStatus varchar(255)
);

CREATE TABLE messages(
  messageID int PRIMARY KEY AUTO_INCREMENT, 
  convID int NOT NULL, 
  messageSenderID varchar(255), 
  messageReceiverID varchar(255), 
  messageStatus varchar(255), 
  messageTextContent varchar(255), 
  messageMediaContentURL varchar(255), 
  messageCreatedAt CURRENT_TIMESTAMP
);

CREATE TABLE conversations( 
  convID int PRIMARY KEY AUTO_INCREMENT, 
  userID1 varchar(255), 
  userID2 varchar(255), 
  convName varchar(255), 
  convCreatedAt CURRENT_TIMESTAMP, 
  convLastMessage int
);

CREATE TABLE posts(
  postID int PRIMARY KEY AUTO_INCREMENT,
  userID varchar(255),
  postTextContent varchar(255),
  postMediaContentURL varchar(255),
  postLinkedActivity varchar(255)
  postLikesNumber int, 
  postCreatedAt CURRENT_TIMESTAMP,
  postCommentsNumber int,
  postType varchar(255)
)

CREATE TABLE likes(
  postID int,
  userID varchar(255)
)

CREATE TABLE comments(
  commentID int,
  userID varchar(255),
  commentTextContent varchar(255),
  commentCreatedAt CURRENT_TIMESTAMP
)
```

## Plan des routes 

- * (get) 404
- / (get) Application React
- /api (get)
    - /websocket (socket.io)
        - score
        - messages
        - notifications
        - conversations
    - /user (get)
        - /activities (get)
        - /friends (get)
            - /search (get)
            - /status (post)
        - /notifications (get)
        - /social (get)
            - /feed (get)
            - /conversations (get) & (post)
                - /messages (get)
    - /activity (get) & (post) & (put) & (delete)
    - /like (post)
    - /comments (post)