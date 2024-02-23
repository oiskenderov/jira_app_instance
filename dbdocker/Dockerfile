# Use the PostgreSQL Alpine image
FROM postgres:10.5-alpine

# Set environment variables
ENV POSTGRES_PASSWORD=jiradbuser
ENV POSTGRES_USER=jiradbuser

# Copy initialization script
COPY ./postgre-db-init.sql /docker-entrypoint-initdb.d/postgre-db-init.sql

# Expose PostgreSQL port
EXPOSE 5432
