# Use an official Ruby runtime as a parent image
FROM ruby:3.1.2

# Set the working directory in the container
WORKDIR /WebOps-/app

# Install any needed packages specified in requirements.txt
RUN apt-get update && apt-get install -y \
    build-essential \
    nodejs \
    postgresql-client \
    redis-server

# Bundle install for dependencies
COPY Gemfile Gemfile.lock ./
RUN bundle install

# Copy the current directory contents into the container at /WebOps-
COPY . .

# Expose port 3000 to the outside world
EXPOSE 3000

# Command to run on container start
CMD ["rails", "server", "-b", "0.0.0.0"]
