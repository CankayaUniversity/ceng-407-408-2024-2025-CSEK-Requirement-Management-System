# Java 21 slim image kullanılıyor
FROM openjdk:21-jdk-slim

# Uygulama dizinini oluştur
WORKDIR /app

# JAR dosyasını container içine kopyala
COPY build/libs/*.jar app.jar

# JAR dosyasını çalıştır
ENTRYPOINT ["java", "-jar", "app.jar"]