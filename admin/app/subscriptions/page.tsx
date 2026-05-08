import { AdminShell } from "../../components/AdminShell";
import { supabaseAdmin } from "../../lib/supabase";

export default async function SubscriptionsPage() {
  const { data } = await supabaseAdmin.from("subscriptions").select("id,user_id,plan,status,renewal_date").limit(100);

  return (
    <AdminShell>
      <h1>Subscriptions</h1>
      <div className="card">
        <table>
          <thead><tr><th>User</th><th>Plan</th><th>Status</th><th>Renewal</th></tr></thead>
          <tbody>
            {(data ?? []).map((sub) => (
              <tr key={sub.id}>
                <td>{sub.user_id}</td>
                <td>{sub.plan}</td>
                <td>{sub.status}</td>
                <td>{sub.renewal_date ? new Date(sub.renewal_date).toLocaleDateString() : "None"}</td>
              </tr>
            ))}
          </tbody>
        </table>
      </div>
    </AdminShell>
  );
}
