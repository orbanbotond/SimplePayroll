This project is created based on the "Payroll" case study from the [Agile Software Development Principles And Patterns](https://www.goodreads.com/book/show/84985.Agile_Software_Development_Principles_Patterns_and_Practices) by [Robert.C.Martin](https://en.wikipedia.org/wiki/Robert_C._Martin).

---

The architecture
=
The simple payroll system uses a Domain Model to cover its's Business functionality.
Beside there are Operations which create/update the Domain Model Entities.

The files are organized by business concepts:
 - classification
 - payment_methods
 - schedules
 - union
 - common
 
Each business concept contains:
 - the entities
 - the operations
 - it's tests.

Other component is the Relational Database Persistence component which uses the repository pattern provided by the [ROM-rb](https://rom-rb.org) to persist the Objects from the Domain.
It also contains an array/"in memory" implementation of the Persistence Layer.

---
![alt text](http://www.plantuml.com/plantuml/proxy?cache=no&src=https://raw.githubusercontent.com/orbanbotond/SimplePayroll/master/diagrams/package.md)
---

The code loader is ["Zeitwerk"](https://github.com/fxn/zeitwerk "Zeitwerk") using ["Conventional File Structure"](https://github.com/fxn/zeitwerk#file-structure).
 
---

Use Cases:
=
  1. Add a new employee (with 3 classifications: salaried/hourly/comissioned)
  2. Delete an employee
  3. Post a time card for salaried employee
  4. Post a sales receipt for comissioned employee
  5. Post a union service charge
  6. Change employee details
  7. Run the payroll for today

![alt text](http://www.plantuml.com/plantuml/proxy?cache=no&src=https://raw.githubusercontent.com/orbanbotond/SimplePayroll/master/diagrams/use_cases.md)

---

Use Case Descriptions
--

Use Case 1: Add new Employee
-
A new employee is added. This
Transaction contains the employee's name, address, and assigned
employee number.

The employee record is created with its fields assigned appropriately.

![alt text](http://www.plantuml.com/plantuml/proxy?cache=no&src=https://raw.githubusercontent.com/orbanbotond/SimplePayroll/master/diagrams/add_employee.md)

Use Case 2: Deleting an Employee
-
Employees are deleted.

Use Case 3: Post a Time Card
-
On receipt of a TimeCard transaction, the system will create a time
card record an associate it with the appropriate employee record.

Alternative 1: The selected employee is not hourly

The system will report an error message and take no further action.

Use Case 4: Post a Sales Receipt
-
On receipt of the SalesReceipt Transaction, the system will create a
new salesreceipt record and associate it with the appropriate
commissioned employee.

SalesReceipt <emp_id> <date> <amount>

Alternative 1: The selected employee not commissioned

The system will report an error message.

Use Case 5: Post a Union Service Charge
-
On receipt of this transaction, the system will create a
service-charge record and associate it with the appropriate union
member.

ServiceCharge <member_id> <amount>

Use Case 6: Changing Employee Details
-
The system will alter one of the details of the appropriate employee record.

Use Case 7: Run the Payroll for today
-
On receipt of the payday transaction, the system finds all those
employees that should be paid on the specified date. The system then
determines how much they are owed and pays them according to ther
selected payment method.

![alt text](http://www.plantuml.com/plantuml/proxy?cache=no&src=https://raw.githubusercontent.com/orbanbotond/SimplePayroll/master/diagrams/create_paychecks.md)
---
Development roadmap:
--
![alt text](http://www.plantuml.com/plantuml/proxy?cache=no&src=https://raw.githubusercontent.com/orbanbotond/SimplePayroll/master/diagrams/gantt.md)
---
 Rake Tasks:
  - Reseting the test environment: `PAYROLL_ENVIRONMENT=test rake db:reset` 
  - Reseting the dev environment: `rake db:reset` 
  - Clean our db modifications: `rake db:clean`, note: this only drops the tables listed in our migrations. (rom is a repository it assumes that there could be other things in the DB. It leaves those unchanged.) 
  
