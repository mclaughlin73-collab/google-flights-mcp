FROM node:22-slim 
WORKDIR /app COPY package.json package-lock.json ./ RUN npm ci COPY tsconfig.json tsup.config.ts ./ COPY src/ src/ RUN npm run build ENV PORT=3000 EXPOSE 3000 CMD ["node", "dist/index.js", "--http"]
