import express from 'express'
import { ApolloServer, AuthenticationError } from 'apollo-server-express'
import { typeDefs } from './schema.js'
import resolvers from './resolvers.js'  


const app = express();

// server setup
const server = new ApolloServer({
    typeDefs,
    resolvers,
})

async function startApolloServer() {
    await server.start();
    server.applyMiddleware({ app });
}

startApolloServer().then(() => {
    app.listen({ port: 4000 }, () =>
        console.log(`Server ready at http://localhost:4000${server.graphqlPath}`)
    );
});