const validCategories = ['Nature', 'nature', 'Food', 'food', 'Culture', 'culture', 'Shopping', 'shopping', 'Landmarks', 'landmarks'];

const validateSearchInput = (searchInput) => {
    const validCategoriesUpperCase = validCategories.filter(category => category[0] === category[0].toUpperCase());

    if (searchInput.category && !validCategories.includes(searchInput.category)) {
        // Only show the valid categories with capital letters
        throw new Error(`Invalid category '${searchInput.category}'. Valid categories are: ${validCategoriesUpperCase.join(', ')}`);
    }

    // Check if the radius is a number between 100 and 10000
    if (searchInput.radius && (searchInput.radius < 100 || searchInput.radius > 50000)) {
        throw new Error('Query parameter <radius> must be a number between 100 and 50000, representing the search radius in meters');
    }

    // Check if the location is a valid Point (type: "Point", coordinates: [longitude from -180 to 180, latitude from -90 to 90])
    if (searchInput.location && !validatePoint(searchInput.location)) {
        throw new Error('Query parameter <location> must be of type Point, with longitude from -180 to 180 and latitude from -90 to 90');
    }
};

const validatePoint = (point) => {

    if (point.coordinates[0] < -180 || point.coordinates[0] > 180 || point.coordinates[1] < -90 || point.coordinates[1] > 90){
        return false;
    }

    return true;
};

export { validateSearchInput };
