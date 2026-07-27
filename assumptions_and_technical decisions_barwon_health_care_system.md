# Assumptions

> Note: the assumptions below are on top of what is clearly stated by the business requirements, not a restatement of them.

- Addresses can hold more than one field, including street, city, and country, rather than being a single flat field.
- Drug strength is stored as a string that includes both the value and the unit, for example "10mcg".
- Medicare number is not unique per patient; however, it can be unique among a small group of people, such as family members.
- A single company cannot have two drugs with the same name.
- No two companies can have the same name in the system.
- All information for each entity in the tables is required, except for the medicare number, as discussed earlier.
- The quantity in the prescription table represents the amount taken by the patient for each drug, for example, three or four times.
- Drug names are not unique and can be repeated across different companies.

# Additional Technical Decisions

## Address is denormalized directly into the patient and pharmaceutical company tables rather than having a shared address table.

**Reasons:**

1. In terms of a polymorphic relationship, this would come at the expense of referential integrity, since for each table we would have to store the name of the referenced table along with the record id, and the table name alone does not guarantee referential integrity.
2. Reversing the relationship, by making address the parent table and the others child tables, leads to logical errors, such as needing to create an address before creating the patient. Solving this would require additional complexity, such as triggers and transactions, just to ensure data integrity and consistency.
3. Since only two tables actually need an address, introducing a whole new table would add unnecessary performance overhead due to the extra joins required.

## Adding an id to the drugs table, even though name and company_id together could be unique.

**Reasons:**

1. To avoid the burden of a composite foreign key, since it would introduce additional columns into every table connected to the drugs table.
2. Company_id logically belongs in the drugs table, as required by the business rules.

## Adding an id to the prescriptions table.

**Reason:**

1. The combination of doctor_id, ur_number, drug_id, and date is not 100% guaranteed to be unique.

## Adding an id to the company table.

**Reason:**

1. To avoid the burden of cascading updates. If a company's name were to change, this would require updating that name everywhere it's used as a foreign key in the drugs table, introducing unnecessary performance overhead.

## Introducing nonclustered indexes based on expected query patterns, to enhance database performance.