
FROM eclipse-temurin:21.0.2_13-jdk-jammy

ENV SPRING_PROFILES_ACTIVE=prod

RUN apt-get update && \
    apt-get install -y --no-install-recommends curl && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /app

COPY target/novabank-transfer.jar app.jar

RUN useradd --system --create-home --shell /usr/sbin/nologin appuser && \
    chown -R appuser:appuser /app

USER appuser

EXPOSE 8082

HEALTHCHECK --interval=30s --timeout=5s --start-period=30s --retries=3 \
    CMD curl -f http://localhost:8082/ || exit 1

CMD ["java", "-jar", "app.jar"]
