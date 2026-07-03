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
// isar_flutter_libs hardcodes an old compileSdkVersion (30), which breaks resource
// linking against newer AndroidX (android:attr/lStar, API 31+). Register an
// afterEvaluate at root-config time (before the plugin evaluates) so our callback
// runs before AGP reads/locks compileSdk, letting SDK 34 win. Scoped to that one
// plugin because newer plugins read compileSdk eagerly and must not be touched.
subprojects {
    if (project.name == "isar_flutter_libs") {
        project.afterEvaluate {
            project.extensions.configure<com.android.build.gradle.LibraryExtension> {
                compileSdk = 34
            }
        }
    }
}
subprojects {
    project.evaluationDependsOn(":app")
    project.plugins.whenPluginAdded {
        if (this is com.android.build.gradle.LibraryPlugin) {
            project.extensions.configure<com.android.build.gradle.LibraryExtension> {
                if (namespace.isNullOrEmpty()) {
                    namespace = project.group.toString().ifEmpty { "dev.${project.name.replace("-", "_")}" }
                }
            }
        }
    }
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}
