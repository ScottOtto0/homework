#Scott Otto Flask portion Homework 10


# Design a Flask API based on the queries that you have just developed
# Use Flask to create your routes per instructions
import numpy as np
import pandas as pd
import datetime as dt 

import sqlalchemy
from sqlalchemy.ext.automap import automap_base
from sqlalchemy.orm import Session
from sqlalchemy import create_engine, func

engine = create_engine("sqlite:///Resources/hawaii.sqlite")

# reflect an existing database into a new model
Base = automap_base()
# reflect the tables
Base.prepare(engine, reflect=True)

# Save references to each table
Measurement = Base.classes.measurement
Station = Base.classes.station

# Create our session (link) from Python to the DB
session = Session(engine)

from flask import Flask, jsonify

from sqlalchemy.orm import scoped_session, sessionmaker
db_session = scoped_session(sessionmaker(autocommit=False,
                                         autoflush=False,
                                         bind=engine))

#engine, Base and session were created in cells 5-9 above

####### FLASK SETUP ########
app = Flask(__name__)


####### FLASK ROUTES #######
# home page
#list all routes available
@app.route('/api/v1.0')
def home():
    """List all avalable api routes."""

    return (
        f'Avalable Routes:<br/>'
        f'/api/v1.0/precipitation<br/>'
        f'/api/v1.0/stations<br/>'
        f'/api/v1.0/tobs<br/>'
        f'<br/>'
        f'Replace startDate with desired beginning date.<br/>'
        f'Enter date in yyyy-mm-dd format.<br/>'
        f'/api/v1.0/startDate<br/>'
        f'<br/>'
        f'Replace startDate/endDate with desired dates.<br/>'
        f'Enter dates in yyyy-mm-dd format.<br/>'
        f'/api/v1.0/startDate/endDate<br/>'
    )

#Convert the query results to a Dictionary using `date` as the key and `prcp` as the value.
@app.route('/api/v1.0/precipitation')
def precipitation():
    """Return a list of precipitation amounts."""
#query precipitation amounts
    results = session.query(Measurement.date, Measurement.prcp).all()
    
    prcpData = []
    for date, prcp in results:
        prcpDict = {}
        prcpDict["date"] = date
        prcpDict["prcp"] = prcp
        prcpData.append(prcpDict)

    return jsonify(prcpData)

# Climate Stations
# Return a JSON list of stations from the dataset.
@app.route('/api/v1.0/stations')
def stations():
    """Return a list of stations"""
#query stations
    results = session.query(Station).all()

    stationList = []
    for result in results:
        stationDict = {}
        stationDict["station"] = result.station
        stationDict["name"] = result.name
        stationList.append(stationDict)


    return jsonify(stationList)

# Temperature data
#query for the dates and temperature observations from a year from the last data point.
#Return a JSON list of Temperature Observations (tobs) for the previous year.
@app.route('/api/v1.0/tobs')
def tobs():
    """Return temperature data"""
    mostRecentEntry = session.query(Measurement.date, Measurement.tobs).order_by(Measurement.id.desc()).first()

    pastYear = session.query(Measurement.date, Measurement.tobs).all()
    lastEntry = mostRecentEntry[0]

    #calculate the previous year by taking the year from the last entry and subtracting 1
    lastYear = int(lastEntry[:4])-1

    #take the year and add it to the day and month of the last entry as a string
    yearAgo = str(lastYear)+lastEntry[4:]

    temperature = session.query(Measurement.tobs).filter(Measurement.date >= yearAgo).order_by(Measurement.date).all()

    tempsList =[]
    for result in temperature:
        tempsList.append(result)

    return jsonify(tempsList)



# Temperature data for a date
#Return a JSON list of the minimum temperature, the average temperature, and the max temperature for a given start.
#When given the start only, calculate `TMIN`, `TAVG`, and `TMAX` for all dates greater than and equal to the start date.
@app.route('/api/v1.0/<start>')
def start_date(start):
    startDate = dt.datetime.strptime(start, '%Y-%m-%d')
    results = session.query(func.min(Measurement.tobs),\
        func.max(Measurement.tobs),\
        func.avg(Measurement.tobs)).\
        filter(Measurement.date >= startDate).all()

    return jsonify(results)
   

# Temperature stats for a range of dates
#Return a JSON list of the minimum temperature, the average temperature, and the max temperature for a given start-end range.
#When given the start and the end date, calculate the `TMIN`, `TAVG`, and `TMAX` for dates between the start and end date inclusive.
@app.route('/api/v1.0/<start>/<end>')
def date_range(start, end):
    startDate = dt.datetime.strptime(start, '%Y-%m-%d')
    endDate = dt.datetime.strptime(end, '%Y-%m-%d')
    results = session.query(func.min(Measurement.tobs),\
        func.max(Measurement.tobs),\
        func.avg(Measurement.tobs)).\
        filter(Measurement.date >= startDate,\
        Measurement.date <= endDate).all()

    return jsonify(results)

if __name__ == '__main__':
    app.run(debug=True)

        




        
        