import { AdminShell } from "../../components/AdminShell";

export default function NotificationsPage() {
  return (
    <AdminShell>
      <h1>Push notifications</h1>
      <div className="card">
        <h2>Campaign composer</h2>
        <p>Create meal reminders, water reminders, weekly reports, and premium announcements. Connect FCM/APNs keys in Supabase Edge Functions before sending production campaigns.</p>
        <button>Schedule campaign</button>
      </div>
    </AdminShell>
  );
}
