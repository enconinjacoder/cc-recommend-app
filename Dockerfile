FROM eclipse-temurin:17-jdk

# Install dependencies and Chrome driver
RUN apt-get update && apt-get install -y \
    wget \
    gnupg \
    unzip \
    fonts-liberation \
    libnss3 \
    libx11-xcb1 \
    libxcomposite1 \
    libxcursor1 \
    libxdamage1 \
    libxrandr2 \
    libasound2t64 \
    libatk1.0-0 \
    libatk-bridge2.0-0 \
    libcups2 \
    libdbus-1-3 \
    libdrm2 \
    libgbm1 \
    libgtk-3-0 \
    libpango-1.0-0 \
    libpangocairo-1.0-0 \
    libxss1 \
    xdg-utils \
    ca-certificates \
    libvulkan1 \
    --no-install-recommends && \
    rm -rf /var/lib/apt/lists/*

# Install specific version of Chrome
RUN wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb \
 && apt-get install -y ./google-chrome-stable_current_amd64.deb \
 && rm google-chrome-stable_current_amd64.deb

# Use matching ChromeDriver version (update URL as needed)
RUN wget -O /tmp/chromedriver_linux64.zip https://edgedl.me.gvt1.com/edgedl/chrome/chrome-for-testing/125.0.6422.112/linux64/chromedriver-linux64.zip \
 && unzip /tmp/chromedriver_linux64.zip -d /usr/local/bin/ \
 && mv /usr/local/bin/chromedriver-linux64/chromedriver /usr/local/bin/chromedriver \
 && rm -rf /tmp/chromedriver_linux64.zip /usr/local/bin/chromedriver-linux64 \
 && chmod +x /usr/local/bin/chromedriver

# Set display port to avoid errors
ENV DISPLAY=:99

# Copy your app jar
ARG JAR_FILE=cc-recommend-app-1.jar
COPY ${JAR_FILE} app.jar

EXPOSE 8080
ENTRYPOINT ["java","-Xms256m" ,"-Xmx500m", "-XX:+UseG1GC", "-jar", "/app.jar"]