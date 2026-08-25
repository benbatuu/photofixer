allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

val newBuildDir: Directory =
    rootProject.layout.buildDirectory
        .dir("../../build")
        .get()
rootProject.layout.buildDirectory.value(newBuildDir)

subprojects {
    val newSubprojectBuildDir: Directory = newBuildDir.dir(project.name)
    project.layout.buildDirectory.value(newSubprojectBuildDir)
}

// firebase_auth Kotlin compile needs checker-qual on the classpath (AGP 9 / KGP 2.x).
subprojects {
    pluginManager.withPlugin("org.jetbrains.kotlin.android") {
        dependencies.add("implementation", "org.checkerframework:checker-qual:3.49.3")
    }
    pluginManager.withPlugin("kotlin-android") {
        dependencies.add("implementation", "org.checkerframework:checker-qual:3.49.3")
    }
}

subprojects {
    project.evaluationDependsOn(":app")
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}
