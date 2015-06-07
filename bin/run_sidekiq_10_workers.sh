#!/bin/sh
export DATABASE_URL='postgres://compgeo@localhost:5432/compgeocode_dev?pool=15'
sidekiq -c 10
