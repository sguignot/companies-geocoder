#!/bin/sh
export DATABASE_URL='postgres://compgeo@localhost:5432/compgeocode_dev?pool=5'
sidekiq -c 1
