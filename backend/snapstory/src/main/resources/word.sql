-- MySQL dump 10.13  Distrib 8.0.30, for Win64 (x86_64)
--
-- Host: localhost    Database: snapstorydb
-- ------------------------------------------------------
-- Server version	8.0.30

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `word`
--

DROP TABLE IF EXISTS `word`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `word` (
  `word_id` int NOT NULL AUTO_INCREMENT,
  `image` varchar(255) NOT NULL,
  `word_eng` varchar(255) NOT NULL,
  `word_explanation_eng` varchar(255) NOT NULL,
  `word_explanation_kor` varchar(255) NOT NULL,
  `word_kor` varchar(255) NOT NULL,
  PRIMARY KEY (`word_id`)
) ENGINE=InnoDB AUTO_INCREMENT=46 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `word`
--

LOCK TABLES `word` WRITE;
/*!40000 ALTER TABLE `word` DISABLE KEYS */;
INSERT INTO `word` VALUES (1,'assets/airplane.png','airplane','a powered flying vehicle with fixed wings and a weight greater than that of the air it displaces','날개가 고정된 동력을 이용하여 공중에서 비행하는 탈것으로, 주로 대기 중의 공기보다 무거운 무게를 가지고 있음','비행기'),(2,'assets/apple.png','apple','a round fruit with red, yellow, or green skin and firm white flesh','껍질이 빨강, 노랑, 초록이고 과육이 단단하고 하얀 둥근 과일','사과'),(3,'assets/ball.png','ball','a usually round object that is used in a game or sport or as a toy','게임, 스포츠 또는 장난감으로 사용되는 보통 둥근 물체','공'),(4,'assets/banana.png','banana','a long curved fruit with a thick peel that is yellow when it is ripe','익으면 노란색인 두꺼운 껍질을 가진 길고 구부러진 과일','바나나'),(5,'assets/bicycle.png','bicycle','a 2-wheeled vehicle that a person rides by pushing on foot pedals','사람이 페달을 밟아 타는 이륜차','자전거'),(6,'assets/book.png','book','a written or printed work consisting of pages glued or sewn together along one side and bound in covers','한 쪽면을 딱딱하게 깔아 붙이거나 꿰매어 만든 페이지들로 이루어진 쓰거나 인쇄된 작품이며, 표지로 묶여 있음','책'),(7,'assets/broccoli.png','broccoli','a cabbage of a variety that bears heads of green or purplish flower buds that are eaten as a vegetable','초록색 또는 자주색 꽃봉오리를 열매로 가지고, 채소로서 섭취되는 종류의 양배추','브로콜리'),(8,'assets/burger.png','burger','a flat round cake of minced beef that is fried or grilled and typically served in a bread roll','다진 소고기로 만든 평평하고 둥근 케이크로, 튀겨서 또는 그릴에 구워서 일반적으로 빵에 싸 먹는 음식','버거'),(9,'assets/bus.png','bus','a large vehicle that is used for carrying passengers especially along a particular route at particular times','특히 특정 시간에 특정 경로를 따라 승객을 운반하는 데 사용되는 대형 차량','버스'),(10,'assets/cake.png','cake','a sweet baked food made from a mixture of flour, sugar, and other ingredients (such as eggs and butter)','밀가루, 설탕 및 다른 재료(예: 계란과 버터)의 혼합물로 만든 달콤한 구운 음식','케이크'),(11,'assets/candy.png','candy','a sweet food made with sugar or chocolate','설탕이나 초콜릿으로 만든 달콤한 음식','사탕'),(12,'assets/cap.png','cap','a small, soft hat that often has a hard curved part (called a visor) that extends out over your eyes','눈 위로 뻗은 딱딱한 곡선 부분(바이저라고 함)이 종종 있는 작고 부드러운 모자','모자'),(13,'assets/cat.png','cat','a small carnivorous mammal with soft fur, a short snout, and retractable claws','부드러운 모피와 짧은 주둥이, 숨길 수 있는 발톱을 가진 작은 육식 동물','고양이'),(14,'assets/chair.png','chair','a seat for one person that has a back and usually four legs','등이 있고 보통 네 개의 다리가 있는 한 사람을 위한 좌석','의자'),(15,'assets/chopsticks.png','chopsticks','a pair of small sticks used as eating utensils, especially by the Chinese, Japanese and Korean.','특히 중국인, 일본인, 한국인들이 먹는 도구로 사용하는 한 쌍의 작은 막대기.','젓가락'),(16,'assets/cookie.png','cookie','a sweet baked food that is usually small, flat, and round and is made from flour and sugar','밀가루와 설탕으로 만들어진 보통 작고 평평하며 둥글고 달콤한 구운 음식','쿠키'),(17,'assets/crayon.png','crayon','a stick of colored wax that is used for drawing','그림을 그릴 때 사용하는 색 왁스 막대기','색연필'),(18,'assets/cup.png','cup','a small round container that often has a handle and that is used for drinking liquids','종종 손잡이가 있고 액체를 마시는 데 사용되는 작고 둥근 용기','컵'),(19,'assets/dinosaur.png','dinosaur','ne of many reptiles that lived on Earth millions of years ago','수백만년전에 지구에 살았던 많은 파충류들 중 하나','공룡'),(20,'assets/dog.png','dog','a domesticated carnivorous mammal that typically has a long snout, an acute sense of smell, nonretractable claws, and a barking, howling, or whining voice','일반적으로 긴 주둥이, 예민한 후각, 숨길 수 없는 발톱, 짖거나 울거나 울음소리를 내는 길들여진 육식 동물','강아지'),(21,'assets/duck.png','duck','any one of many different kinds of birds that swim and have a flat beak, a short neck, a heavy body, short legs, and webbed feet','평평한 부리, 짧은 목, 무거운 몸, 짧은 다리, 물갈퀴가 달린 발을 가진 많은 다른 종류의 새들 중 하나','오리'),(22,'assets/eraser.png','eraser','a small piece of rubber or other material that is used to erase something you have written or drawn','쓰거나 그린 것을 지우는 데 사용되는 작은 고무 조각 또는 다른 재료','지우개'),(23,'assets/firetruck.png','firetruck','a vehicle equipped for firefighting, typically including a large tank for water and hoses for spraying it','일반적으로 대형 물탱크와 분무용 호스를 갖춘 소방활동에 사용되는 차량','소방차'),(24,'assets/flower.png','flower','the part of a plant that produces seeds, usually made up of colorful petals','보통 알록달록한 꽃잎으로 이루어진 씨앗을 생산하는 식물의 부분','꽃'),(25,'assets/fork.png','fork','a small tool with two or more pointed parts used for picking up and eating food','음식을 집어서 먹는 데 사용되는 두 개 이상의 뾰족한 부분이 있는 작은 도구','포크'),(26,'assets/glasses.png','glasses','a pair of lenses set in a frame resting on the nose and ears, used to correct or assist defective eyesight.','결함이 있는 시력을 교정하거나 보조하는 데 사용되는 코와 귀에 있는 프레임에 설치된 한 쌍의 렌즈.','안경'),(27,'assets/grape.png','grape','green, dark red, or purplish-black berry that is used to make wine or is eaten as a fruit','포도주를 만드는 데 사용되거나 과일로 먹는 녹색, 짙은 빨강 또는 자줏빛 검은 베리','포도'),(28,'assets/icecream.png','icecream','a frozen sweet food made from milk and cream and typically flavored with fruit or other ingredients','우유와 크림에서 만들어진 얼음으로 된 달콤한 음식으로 일반적으로 과일이나 다른 재료로 향을 냄','아이스크림'),(29,'assets/milk.png','milk','the milk of cows, used as food by humans','소의 젖으로, 인간이 음식으로 사용','우유'),(30,'assets/orange.png','orange','a large round juicy citrus fruit with a tough bright reddish-yellow rind','담홍색이 도는 껍질을 가진 크고 둥글고 즙이 많은 과일로 시트러스류','오렌지'),(31,'assets/pencil.png','pencil','a thin rod of graphite, colored wax, or similar material, used for writing or drawing','글씨를 쓰거나 그림을 그리기 위해 사용되는, 그래핏, 유색 왁스 또는 유사한 물질의 얇은 막대','연필'),(32,'assets/penguin.png','penguin','a flightless seabird of the southern hemisphere, having webbed feet and wings modified as flippers','지느러미로 변형된 날개와 발가락 사이에 막이 있는 남쪽 반구의 비행할 수 없는 바닷새','펭귄'),(33,'assets/piano.png','piano','a large keyboard musical instrument with a wooden case enclosing a soundboard and metal strings, which are struck by hammers when the keys are depressed','건반을 누르면 망치가 금속 줄에 치는 소리를 내며, 나무로 된 케이스에 소리판을 감싸고 있는 대형의 키보드 악기','피아노'),(34,'assets/pizza.png','pizza','a dish of Italian origin consisting of a flat, round base of dough baked with a topping of tomatoes and cheese, typically with added meat, fish, or vegetables','이탈리아 원산지의 요리로, 평평하고 둥근 반죽의 바닥에 토마토와 치즈로 만든 토핑이 올라가며 종종 고기, 생선 또는 야채가 추가된','피자'),(35,'assets/policecar.png','policecar','a vehicle used by the police for transporting officers, carrying equipment, and pursuing criminals','경찰이 장비를 운반하거나 범인을 추격하기 위해 사용하는 차량','경찰차'),(36,'assets/scissors.png','scissors','a tool with two sharp blades that are used to cut things like paper, hair, or fabric','종이, 머리카락, 천 등을 자르는 데 사용되는 두 개의 날로 이루어진 날카로운 도구','가위'),(37,'assets/socks.png','socks','pieces of clothing that people wear on their feet, which keep peoples\' feet warm and cozy','사람들이 발에 신는 옷으로, 발을 따뜻하고 아늑하게 해주는 것','양말'),(38,'assets/spoon.png','spoon','a tool people use to eat or stir things, which has a small bowl at one end and a handle on the other','먹거나 젓는 데 사용하는 도구로, 한쪽 끝에 작은 그릇이 있고 다른 한쪽 끝에는 손잡이가 달려있는 것','숟가락'),(39,'assets/strawberry.png','strawberry','a sweet and juicy fruit that is usually red and has little seeds on the outside','보통 빨간색이며 바깥쪽에 작은 씨앗이 있는 달콤하고 즙이 많은 과일','딸기'),(40,'assets/table.png','table','a piece of furniture with a flat top and usually four legs, where people can eat, draw or do work','평평한 윗면과 대개 네 개의 다리가 있는 가구로, 식사를 하거나 그림을 그리거나 일을 할 수 있는 것','책상'),(41,'assets/tiger.png','tiger','a big, striped cat with sharp teeth and claws that lives in the forest','크고 줄무늬가 있으며 날카로운 이빨과 발톱을 가지고 숲에서 사는 고양잇과 동물','호랑이'),(42,'assets/toothbrush.png','toothbrush','a tool with bristles that you use to clean peoples\' teeth','사람이 이를 닦는 데 사용하는 솔이 달린 도구','칫솔'),(43,'assets/tree.png','tree','a big plant with a trunk and branches that grows outside and can have leaves or fruit','줄기와 가지가 있는 큰 식물로, 실외에서 자라며 나뭇잎이나 과일이 달리기도 하는 것','나무'),(44,'assets/tv.png','television','a machine that shows moving pictures and sound, like a movie, and people usually watch at home','영화처럼 움직이는 그림과 소리를 보여주는 기계로, 사람들이 대부분 집에서 시청하는 것','티비'),(45,'assets/window.png','window','a hole in the wall that lets in light and air and usually contains a sheet of glass','빛과 공기가 들어오게 해주는 벽의 구멍으로, 일반적으로 유리 판으로 만들어진 것','창문');
/*!40000 ALTER TABLE `word` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2023-03-16 13:28:41