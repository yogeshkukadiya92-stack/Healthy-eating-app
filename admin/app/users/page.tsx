import { AdminShell } from "../../components/AdminShell";
import { supabaseAdmin } from "../../lib/supabase";

export default async function UsersPage() {
  const { data } = await supabaseAdmin.from("profiles").select("id,name,email,created_at,calorie_goal,protein_goal").limit(50);

  return (
    <AdminShell>
      <h1>Users</h1>
      <div className="card">
        <table>
          <thead><tr><th>Name</th><th>Email</th><th>Calories</th><th>Protein</th><th>Joined</th></tr></thead>
          <tbody>
            {(data ?? []).map((user) => (
              <tr key={user.id}>
                <td>{user.name ?? "Unnamed"}</td>
                <td>{user.email}</td>
                <td>{user.calorie_goal}</td>
                <td>{user.protein_goal}g</td>
                <td>{new Date(user.created_at).toLocaleDateString()}</td>
              </tr>
            ))}
          </tbody>
        </table>
      </div>
    </AdminShell>
  );
}
