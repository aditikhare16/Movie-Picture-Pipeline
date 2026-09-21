import React, { useState, useEffect } from 'react';
import PropTypes from 'prop-types';
import axios from 'axios';

function MovieDetail({ movie }) {
  const [details, setDetails] = useState(null);

  useEffect(() => {
    if (!movie) return;
    axios.get(`http://accdda5a326a24493a81f1394950bf43-604742334.us-east-1.elb.amazonaws.com/movies/${movie.id}`).then((response) => {
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

MovieDetail.propTypes = {
  movie: PropTypes.object,
};

export default MovieDetail;