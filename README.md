# reciPhoto

A business-trip management web app: snap a receipt and the expense is entered automatically, plan trips on a shared calendar, and see trip costs as charts.

Team project built in 2018 (SESOC bootcamp); dependencies refreshed in 2026.

Demo video: https://youtu.be/w1b0tqASMMA

<img width="1280" alt="reciPhoto screenshot" src="https://user-images.githubusercontent.com/39237004/80807040-1abd0680-8bf7-11ea-84c4-20baa6bbeb9a.png">

## Features

- **Automatic receipt entry** — receipt images are processed with OpenCV (perspective correction, feature matching) and Google Cloud Vision OCR to extract amounts and items
- **Trip schedule management** — calendar view (FullCalendar + Google Calendar) for planning business trips and adding coworkers
- **Trip cost statistics** — cost breakdowns by employee, region and company using Google Charts
- Employee sign-up / login with manager and employee roles

## Tech stack

- Java 17, Spring MVC 5.3 (XML configuration), JSP + JSTL
- MyBatis, Oracle Database
- OpenCV 2.4, Google Cloud Vision API
- jQuery, FullCalendar, Google Charts
- Maven (WAR packaging)

## Running locally

Requirements: JDK 17, Maven, an Oracle database (e.g. Oracle XE), and a servlet container such as Tomcat 9.

1. Create the schema and point `src/main/resources/db.properties` at your database.
2. Set environment variables:
   - `GOOGLE_APPLICATION_CREDENTIALS` — path to a Google Cloud service-account JSON with the Vision API enabled
   - `GOOGLE_MAPS_API_KEY` — key used by the statistics map chart
3. Build and deploy:

   ```bash
   mvn package
   # deploy target/team-1.0.0-BUILD-SNAPSHOT.war to Tomcat 9
   ```

Tomcat 10+ is not supported (it requires `jakarta.*` packages; this app uses `javax.*`).

## Known limitations

This is a 2018 learning project and is not production-ready. In particular, passwords are stored in plain text, and the OpenCV and Cloud Vision client versions are the ones from 2018.

## 2026 update

- Spring 4.3 → 5.3, Java 8 → 17, MyBatis 3.5.16 / mybatis-spring 2.1
- Security updates: Jackson 2.9 → 2.17, commons-fileupload 1.3 → 1.5, log4j 1.2.15 → reload4j (drop-in maintained fork)
- Oracle JDBC driver now comes from Maven instead of a committed jar
- Google Maps API key moved out of the JSP into an environment variable
- Removed committed build output (`target/`) and Eclipse project files; added `.gitignore`
