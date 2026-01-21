import os
import re

# Directory containing migration files
migrations_dir = 'migrations'

# Regular expression to find table references
table_ref_pattern = re.compile(r'\b(insert into|update|delete from|select .* from)\s+(\w+)\b', re.IGNORECASE)

# Function to check if a table reference is fully qualified
def is_fully_qualified(reference):
    return '.' in reference

# Iterate over each file in the migrations directory
for filename in os.listdir(migrations_dir):
    if filename.endswith('.sql'):
        filepath = os.path.join(migrations_dir, filename)
        with open(filepath, 'r') as file:
            content = file.read()
            matches = table_ref_pattern.findall(content)
            for match in matches:
                table_ref = match[1]
                if not is_fully_qualified(table_ref):
                    print(f'Unqualified table reference found in {filename}: {table_ref}')
