export const typeDefs = `#graphql
  type PointOfInterest { 
    _id: ID!
    name: String!
    location: Point!
    locationName: String!
    street: String
    postcode: String
    description: String
    category: String
    thumbnail: String
   }

  input PoiSearchInput {
    _id: ID
    location: PointInput
    radius: Float
    locationName: String
    category: String
  }

  type Point {
    type: String!
    coordinates: [Float]!
  }

  type Query {
    searchPointsOfInterest(searchInput: PoiSearchInput, 
    apiKey: String!): [PointOfInterest!]!
    
    recoverApiKey(clientName: String!, password: String!): String!
  }

  type PointOfInterestWithMessage {
    poi: PointOfInterest!
    message: String!
  }

  input PointInput {
    type: String!
    coordinates: [Float]!
  }

  input CreatePointOfInterestInput {
    name: String!
    location: PointInput!
    locationName: String!
    street: String
    postcode: String
    description: String
    category: String
    thumbnail: String
  }

  input UpdatePointOfInterestInput {
    name: String
    location: PointInput
    locationName: String
    street: String
    postcode: String
    description: String
    category: String
    thumbnail: String
  }

  type Mutation {
    createPointOfInterest(input: CreatePointOfInterestInput!, 
    apiKey: String!): PointOfInterestWithMessage!
    updatePointOfInterest(_id: ID!, input: UpdatePointOfInterestInput!, 
    apiKey: String!): PointOfInterest!
    deletePointOfInterest(_id: ID!, apiKey: String!): String!

    generateApiKey(clientName: String!, password: String!): String!
  }
`