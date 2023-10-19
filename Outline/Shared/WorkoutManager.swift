//
//  WorkoutManager.swift
//  Outline
//
//  Created by 김하은 on 10/15/23.
//
/*
 import Foundation
 import os
 import HealthKit
 
 @MainActor
 class WorkoutManager: NSObject, ObservableObject {
 struct SessionSateChange {
 let newState: HKWorkoutSessionState
 let date: Date
 }
 /**
  The workout session live states that the UI observes.
  */
 @Published var sessionState: HKWorkoutSessionState = .notStarted
 @Published var heartRate: Double = 0
 @Published var activeEnergy: Double = 0
 @Published var speed: Double = 0
 @Published var power: Double = 0
 @Published var cadence: Double = 0
 @Published var distance: Double = 0
 @Published var water: Double = 0
 @Published var pace: Double = 0
 @Published var elapsedTimeInterval: TimeInterval = 0
 /**
  SummaryView (watchOS) changes from Saving Workout to the metric summary view when
  a workout changes from nil to a valid value.
  */
 @Published var workout: HKWorkout?
 /**
  HealthKit data types to share and read.
  */
 let typesToShare: Set = [HKQuantityType.workoutType(),
 HKQuantityType(.dietaryWater)]
 let typesToRead: Set = [
 HKQuantityType(.heartRate),
 HKQuantityType(.activeEnergyBurned),
 HKQuantityType(.distanceWalkingRunning),
 HKQuantityType(.runningSpeed),
 HKQuantityType(.runningPower),
 HKQuantityType(.cyclingCadence),
 HKQuantityType(.distanceWalkingRunning),
 HKQuantityType(.dietaryWater),
 HKQuantityType.workoutType(),
 HKObjectType.activitySummaryType()
 ]
 let healthStore = HKHealthStore()
 var session: HKWorkoutSession?
 #if os(watchOS)
 /**
  The live workout builder that is only available on watchOS.
  */
 var builder: HKLiveWorkoutBuilder?
 #else
 /**
  A date for synchronizing the elapsed time between iOS and watchOS.
  */
 var contextDate: Date?
 #endif
 /**
  Creates an async stream that buffers a single newest element, and the stream's continuation to yield new elements synchronously to the stream.
  The Swift actors don't handle tasks in a first-in-first-out way. Use AsyncStream to make sure that the app presents the latest state.
  */
 let asynStreamTuple = AsyncStream.makeStream(of: SessionSateChange.self, bufferingPolicy: .bufferingNewest(1))
 /**
  WorkoutManager is a singleton.
  */
 static let shared = WorkoutManager()
 }
 // MARK: - Workout session management
 //
 extension WorkoutManager {
 func requestAuthorization() {
 Task {
 do {
 try await healthStore.requestAuthorization(toShare: typesToShare, read: typesToRead)
 } catch {
 Logger.shared.log("Failed to request authorization: \(error)")
 }
 }
 }
 
 func resetWorkout() {
 #if os(watchOS)
 builder = nil
 #endif
 workout = nil
 session = nil
 activeEnergy = 0
 heartRate = 0
 distance = 0
 water = 0
 power = 0
 cadence = 0
 speed = 0
 pace = 0
 sessionState = .notStarted
 }
 }
 */
