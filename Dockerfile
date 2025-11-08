ARG node_version=22
ARG ALPINE_VERSION=3.21

FROM node:${NODE_VERSION}-alpine${ALPINE_VERSION}

# use produciton node environment by default
ENV NODE_ENV produciton

WORKDIR /usr/src/app

# Install Dependancies: npm ci --omit=dev
#  Node = /root/.npm, Python = /.cache/pip 
# Leverage a cache mount /root/.npm to speed up subsequent builds
RUN --mount=type=bind,source=package.json,target=package.json \
    --mount=type=bind,source=package-lock.json,target=package-lock.json \
    --mount=type=cache,target=/root/.npm \
    npm ci --omit=dev

USER node

COPY . .
EXPOSE 3000

CMD node src/index.js