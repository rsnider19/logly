import { copycat } from "@snaplet/copycat";
import { v4 } from "uuid";

for (let i = 0; i < 10; i++) {
  await fetch(
    'http://127.0.0.1:54321/auth/v1/admin/users',
    {
      method: 'POST',
      body: JSON.stringify({
        email: `${copycat.firstName(i)}@foo.com`,
        password: "Test123#",
        email_confirm: true,
      }),
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZS1kZW1vIiwicm9sZSI6InNlcnZpY2Vfcm9sZSIsImV4cCI6MTk4MzgxMjk5Nn0.EGIM96RAZx35lJzdJsyH-qQwv8Hdp7fsn3W0YpN81IU',
        'Content-Type': 'application/json',
        'Origin': 'http://127.0.0.1:54323',
        'Referer': 'http://127.0.0.1:54323/project/default/auth/users'
      }
    }
  );
}
