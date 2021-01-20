# Spring Boot based application (PetClinic)

It is used for testing [AWS native CI/CD flow](https://github.com/aws-cd/IaC).

Apart from sources it includes:
* [buildspec.yml](https://github.com/aws-cd/app1/blob/master/buildspec.yml), main `CodeBuild` spec, for building and packaging application
* [buildspec_test.yml](https://github.com/aws-cd/app1/blob/master/buildspec_test.yml), `CodeBuild` basic testing spec, for code quality checks with `SonarCloud` and unit testing
* [buildspec_test_func.yml](https://github.com/aws-cd/app1/blob/master/buildspec_test_func.yml), `CodeBuild` functional testing spec, for `Selenium`-based tests
* [scripts/petclinic_start.sh](https://github.com/aws-cd/app1/blob/master/scripts/petclinic_start.sh), application launching script used by `systemd`
* [scripts/jar_to_deb.sh](https://github.com/aws-cd/app1/blob/master/scripts/jar_to_deb.sh), script to build application `jar` and pack it into `deb` package
* [scripts/test_func.py](https://github.com/aws-cd/app1/blob/master/scripts/test_func.py), `Selenium`-based functional testing script

NOTE: `CodeBuild` performance testing spec [artillery/buildspec.yml](https://github.com/aws-cd/IaC/blob/docs/modules/spinnaker/artillery/buildspec.yml) currently resides in `IaC` repository, `spinnaker` module. **It's a subject for refactoring**
