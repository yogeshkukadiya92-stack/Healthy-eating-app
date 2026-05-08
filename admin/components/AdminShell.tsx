import Link from "next/link";
import type { ReactNode } from "react";

export function AdminShell({ children }: { children: ReactNode }) {
  return (
    <main className="shell">
      <aside className="sidebar">
        <div className="brand">Aura Admin</div>
        <nav className="nav">
          <Link href="/">Overview</Link>
          <Link href="/users">Users</Link>
          <Link href="/foods">Food database</Link>
          <Link href="/subscriptions">Subscriptions</Link>
          <Link href="/notifications">Push notifications</Link>
          <Link href="/moderation">AI moderation</Link>
        </nav>
      </aside>
      <section className="content">{children}</section>
    </main>
  );
}
