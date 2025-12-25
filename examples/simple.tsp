import "@omnidotdev/typespec-drizzle";

using Drizzle;

namespace Simple;

@table(#{ name: "users" })
model User {
  @id
  id: string;

  @unique
  email: string;

  name: string;

  @defaultValue("now()")
  createdAt: utcDateTime;
}

@table(#{ name: "posts" })
model Post {
  @id
  id: string;

  title: string;
  content: string;

  @manyToOne(#{ fields: "authorId", references: "id" })
  authorId: string;

  @defaultValue("now()")
  createdAt: utcDateTime;
}
