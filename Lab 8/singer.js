db.songs.insertMany([
  {
    songId: 1,
    title: "Shape of You",
    singer: { name: "Ed Sheeran", age: 32 },
    album: "Divide",
    releaseYear: 2017,
    genres: ["Pop", "Dance"],
    duration: 233, // in seconds
    ratings: [5, 4, 5, 5, 4]
  },
  {
    songId: 2,
    title: "Blinding Lights",
    singer: { name: "The Weeknd", age: 33 },
    album: "After Hours",
    releaseYear: 2020,
    genres: ["Synthwave", "Pop"],
    duration: 200,
    ratings: [5, 5, 4, 4, 5]
  },
  {
    songId: 3,
    title: "Someone Like You",
    singer: { name: "Adele", age: 35 },
    album: "21",
    releaseYear: 2011,
    genres: ["Soul", "Pop"],
    duration: 285,
    ratings: [5, 5, 5, 4, 5]
  },
  {
    songId: 4,
    title: "Levitating",
    singer: { name: "Dua Lipa", age: 28 },
    album: "Future Nostalgia",
    releaseYear: 2020,
    genres: ["Pop", "Dance"],
    duration: 203,
    ratings: [4, 5, 4, 4, 4]
  }
]);
