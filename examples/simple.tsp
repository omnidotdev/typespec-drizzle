import "@omnidotdev/typespec-drizzle";

using Drizzle;

namespace Simple;

@table(#{ name: "users" })
model User {
  @id
  @uuid
  id: string = Defaults.uuidv4;

  @unique
  email: string;

  name: string;
  createdAt: utcDateTime = Defaults.currentTimestamp;
}

@table(#{ name: "posts" })
model Post {
  @id
  @uuid
  id: string = Defaults.uuidv4;

  title: string;
  content: string;

  @manyToOne(#{ fields: "authorId", references: "id" })
  authorId: string;

  createdAt: utcDateTime = Defaults.currentTimestamp;
}
