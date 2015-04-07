#!/bin/sh
export DATABASE_URL='postgres://compgeo@localhost:5432/compgeo_dev?pool=50'
sidekiq -c 40
