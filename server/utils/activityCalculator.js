const express = require('express');
const router = express.Router();
const { executeQuery } = require('../utils/database.js');

// Co-authored by Gookd

const activity = {
  "heating_emission": {
      "wood_pellet": 6,
      "electric": 8,
      "wood_stove": 9,
      "gas": 39,
      "fuel_oil": 57
  },
  "vehicle_emission": {
      "Large hybrid car": 110,
      "Medium hybrid car": 100,
      "Small hybrid car": 80,
      "Large car": 195,
      "Medium car": 180,
      "Small car": 175,
      "electric_car": 20,
      "motorcycle": 165,
      "bus": 110,
      "plane": 250,
      "train": 22,
      "subway": 10,
      "high_speed_train": 2.3,
      "on_foot": 0,
      "bike": 0,
      "electric_bike_or_scooter": 2,
      "metro": 4.2,
      "tram": 4.3,
      "carpooling": 55
  },
  "article_emission": {
      "newclothes": 10,
      "reusedclothes": 10,
      "appliances": 300,
      "computer": 150,
      "phone": 40
  },
  "food_emission": {
      "vegetarian": 0.5,
      "fatty_fish": 1,
      "white_fish": 2,
      "chicken": 1.6,
      "beef": 7,
      "other_meat": 2
  },
  "furniture_emission": {
      "chair": 19,
      "table": 80,
      "sofa": 180,
      "bed": 450,
      "wardrobe": 900
  }
}

function passiveScore(multiplier, score) {
  if (multiplier > 1) {
      return score + 100 * Math.log(multiplier);
  } else if (multiplier < 1) {
      return score - 100 * Math.log(Math.abs(multiplier));
  }
  return score; // retourne le score inchangé si le multiplier = 1
}

function multiplier(recycle, nb_residents, surface, garden, multiplier, heating) {
  if (recycle) {
      multiplier += 261 * nb_residents;
      if (garden) {
          multiplier += 50 * nb_residents;
      } else {
          multiplier -= 50 * nb_residents;
      }
  } else {
      multiplier -= 261 * nb_residents;
  }
  multiplier += (30 - activity["heating_emission"][heating]) * surface;
  return multiplier;
}

function newTrip(vehicle, distance) {
  return (60 - (activity["vehicle_emission"][vehicle]) * (Math.log(distance) * (1 / 10)));
}

function newPurchase(item, condition) {
  if (condition) { // New
      return activity["article_emission"][item] * -1;
  } else { // Second hand
      return activity["article_emission"][item];
  }
}

function newMeal(food) {
  return (1 - activity["food_emission"][food]) * 10;
}

function renovation(meuble) {
  return activity["furniture_emission"][meuble];
}

function inbox(mail_test) { // To be tested by the user every week
  if (mail_test) { // User emptied inbox
      return 5;
  } else { // User didn't empty inbox
      return -5;
  }
}


module.exports = {
  inbox,
  renovation,
  newMeal,
  newPurchase,
  newTrip,
  multiplier,
  passiveScore
}