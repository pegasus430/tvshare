// import { useState, useEffect } from "React";
// import { DragDropContext, Droppable, Draggable } from "react-beautiful-dnd";

import React, { useState, useEffect } from "react";
import ReactDOM from "react-dom";
import { DragDropContext, Droppable, Draggable } from "react-beautiful-dnd";
import ShowSearch from "./ShowSearch";

const grid = 8;
const reorder = (list, startIndex, endIndex) => {
  const result = Array.from(list);
  const [removed] = result.splice(startIndex, 1);
  result.splice(endIndex, 0, removed);

  return result;
};

const QuoteItem = () => {
  return <div style={{background: 'gray'}}></div>;
}

function Quote({ quote, index }) {
  console.log(quote)
  return (
      <Draggable draggableId={quote.tmsId} index={index}>
        {provided => (
          <div
            ref={provided.innerRef}
            {...provided.draggableProps}
            {...provided.dragHandleProps}
          >
          <div style={{background: 'gray', padding: 8}}>
            <img src={quote.preferredImage.uri} />
            <p>{quote.title}</p>
          </div>
          </div>
        )}
      </Draggable>
  );
}
const QuoteList = React.memo(function QuoteList({ quotes }) {
    return quotes.map((quote, index) => (React.createElement(Quote, { quote: quote, index: index, key: quote.tmsId })));
});

function QuoteApp() {
  const [quotes, setQuotes] = useState([]);

  const onDragEnd = (result) => {
    if (!result.destination) {
      return;
    }

    if (result.destination.index === result.source.index) {
      return;
    }

    setQuotes(reorder(
      quotes,
      result.source.index,
      result.destination.index
    ));
  }

  return (
    <div>
      <h3>Category</h3>
      <div >
        <DragDropContext onDragEnd={onDragEnd}>
          <Droppable droppableId="list">
            {provided => (
              <div ref={provided.innerRef} {...provided.droppableProps} style={{display: 'flex', justifyContent: 'space-between'}}>
                <QuoteList quotes={quotes} />
                {provided.placeholder}
              </div>
            )}
          </Droppable>
        </DragDropContext>

        <div>
          <h4>Add Show</h4>
          <ShowSearch onClick={(row) => setQuotes(quotes.concat(row)) }/>
        </div>
      </div>
    </div>
  );
}

export default QuoteApp;
