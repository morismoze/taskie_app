import java.util.Properties
import java.io.FileInputStream

val keystoreProperties = Properties()
val keystorePropertiesFile = rootProject.file("key.properties")
if (keystorePropertiesFile.exists()) {
    keystoreProperties.load(FileInputStream(keystorePropertiesFile))
}

plugins {
    id("com.android.application")
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.taskie.taskie"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = "27.0.12077973"

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
    }

    defaultConfig {
        applicationId = "com.taskie.taskie"
        // You can update the following values to match your application needs.
        // For more information, see: https://flutter.dev/to/review-gradle-config.
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    signingConfigs {
        create("production") {
            val alias = keystoreProperties["keyAlias"] as String?
            val keyPass = keystoreProperties["keyPassword"] as String?
            val storePass = keystoreProperties["storePassword"] as String?
            val sFile = keystoreProperties["storeFile"] as String?

            if (alias != null && keyPass != null && storePass != null && sFile != null) {
                keyAlias = alias
                keyPassword = keyPass
                storePassword = storePass
                storeFile = file(sFile)
            } else {
                // Fallback to debug if nothing is set
                initWith(getByName("debug"))
            }
        }
    }

    buildTypes {
        release {
            signingConfig = signingConfigs.getByName("production")
            isMinifyEnabled = true
            isShrinkResources = true
            proguardFiles(
                getDefaultProguardFile("proguard-android-optimize.txt"),
                "proguard-rules.pro"
            )
        }
    }

    flavorDimensions += "default"
    productFlavors {
        create("development") {
            dimension = "default"
            applicationIdSuffix = ".dev"
            // App name on the mobile device will be "Taskie Dev"
            resValue("string", "app_name", "Taskie Dev")
        }

        create("production") {
            dimension = "default"
            // App name on the mobile device will be "Taskie"
            resValue("string", "app_name", "Taskie")
            signingConfig = signingConfigs.getByName("production")
        }
    }
}

dependencies {
    implementation("androidx.core:core-splashscreen:1.0.1")
}

flutter {
    source = "../.."
}
