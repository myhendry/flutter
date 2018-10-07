By User
iOS
Facebook OAuth

Vid

In android/app/build.gradle

apply plugin: 'com.google.gms.google-services'

com.google.gms.googleservices.GoogleServicesPlugin.config.disableVersionCheck = true

In android/build.gradle

    dependencies {
        classpath 'com.android.tools.build:gradle:3.1.2'
        classpath 'com.google.gms:google-services:4.0.1'
    }

ISSUE: The number of method references in a .dex file cannot exceed 64k API 17

In android/app/build.gradle

    defaultConfig {
        ...
        multiDexEnabled true
    }
