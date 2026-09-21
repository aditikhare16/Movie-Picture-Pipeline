import React, { useState, useEffect } from 'react';
import PropTypes from 'prop-types';
import axios from 'axios';

const API_URL = 'http://accdda5a326a24493a81f1394950bf43-604742334.us-east-1.elb.amazonaws.com';

function MovieDetails({ movie }) {
  const [details, setDetails] = useState(null);

  useEffect(() => {
    if (!movie) return;
    axios.get(`${API_URL}/movies/${movie.id}`).then((response) => {
      setDetails(response.data);
    });
  }, [movie]);

  return (
    <div>
      <h2>{details?.movie?.title}</h2>
      <p>{details?.movie?.description}</p>
    </div>
  );
}

MovieDetails.propTypes = {
  movie: PropTypes.object,
};

export default MovieDetails;