plugins {
    id("com.android.application")
    id("org.jetbrains.kotlin.android")
    id("com.google.gms.google-services") // ✅ Firebase plugin
    id("dev.flutter.flutter-gradle-plugin") // ✅ Flutter plugin (must be last)
}

android {
    namespace = "com.example.bookhub_apps"

    // ✅ Use the latest SDK for url_launcher & Firebase
    compileSdk = 35

    // ✅ NDK (optional; remove if unused)
    ndkVersion = "27.0.12077973"

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }

    kotlinOptions {
        jvmTarget = "11"
    }

    defaultConfig {
        applicationId = "com.example.bookhub_apps"

        // ✅ Firebase requires minSdk ≥ 23
        minSdk = 23
        targetSdk = 35

        versionCode = 1
        versionName = "1.0"

        // ✅ Recommended for larger apps (Firebase + url_launcher)
        multiDexEnabled = true
    }

    buildTypes {
        release {
            // ✅ Simple debug signing for development
            signingConfig = signingConfigs.getByName("debug")
            isMinifyEnabled = false
            isShrinkResources = false
        }
    }

    // ✅ Avoid conflicts in dependencies
    packagingOptions {
        resources {
            excludes += "/META-INF/{AL2.0,LGPL2.1}"
            excludes += "META-INF/DEPENDENCIES"
            excludes += "META-INF/LICENSE"
            excludes += "META-INF/LICENSE.txt"
            excludes += "META-INF/license.txt"
            excludes += "META-INF/NOTICE"
            excludes += "META-INF/NOTICE.txt"
            excludes += "META-INF/ASL2.0"
        }
    }
}

flutter {
    source = "../.."
}
