#!/bin/sh
#workaround till the dependency management is figured out
gradlew :core:build :core:publishToMavenLocal
gradlew dist
