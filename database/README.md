# AWS database

The Database class is a Python module designed to facilitate the creation and management of an Amazon Web Services (AWS) database. This class abstracts common database-related operations, making it easier to work with AWS databases, for now only works with Amazon RDS (Relational Database Service).

## Methods

- create_database() - Creates a database instance using the kwargs passed as parameters.
- _check_if_database_exists() - Checks if a database already with the same id already exists returning it if True.
- get_database_id() - Returns the database id of the database instance associated with the class.
- get_database_endpoint() - Returns the database endpoint used for public access of the database instance associated with the class, waiting for it to be available.

## Database intance creation parameters

All possible parameters that can be passed to the create_database() can be found in the file [db_instance_params.md](db_instance_params.md).
