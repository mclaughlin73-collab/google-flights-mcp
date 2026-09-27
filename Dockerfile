FROM node:22-slim

WORKDIR /app

# better-sqlite3 is a native module. If a prebuilt binary for this exact
# Node/Debian combo isn't published, npm falls back to compiling from
# source, which needs a C++ toolchain and Python. The slim image doesn't
# ship those by default, so a fallback build silently fails at runtime
# instead of at build time. Installing them here makes the build path
# work either way.
RUN apt-get update \
  && apt-get install -y --no-install-recommends python3 make g++ \
  && rm -rf /var/lib/apt/lists/*

COPY package.json package-lock.json ./
RUN npm ci

COPY tsconfig.json tsup.config.ts ./
COPY src/ src/

RUN npm run build

ENV PORT=3000
EXPOSE 3000

CMD ["node", "dist/index.js", "--http"]
