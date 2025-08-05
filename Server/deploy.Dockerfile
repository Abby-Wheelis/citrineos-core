# Use a specific base image with platform support
FROM --platform=${BUILDPLATFORM:-linux/amd64} node:22 AS build

WORKDIR /usr/local/apps/citrineos

COPY . .
RUN npm run install-all && npm run build

RUN echo "Copying data and hasura metadata folders..."
#list the contents of the local directory


# Copy the data and hasura-metadata folders into the built image
COPY /Server/data /usr/local/apps/citrineos/Server
COPY Server/hasura-metadata /usr/local/apps/citrineos/Server

RUN ls /usr/local/apps/citrineos/Server

# COPY /usr/local/apps/citrineos/hasura-metadata /usr/local/apps/citrineos/Server

# The final stage, which copies built files and prepares the run environment
# Using a slim image to reduce the final image size
FROM node:22-slim
COPY --from=build /usr/local/apps/citrineos /usr/local/apps/citrineos

WORKDIR /usr/local/apps/citrineos

EXPOSE ${PORT}

CMD ["npm", "run", "start-docker-cloud"]
