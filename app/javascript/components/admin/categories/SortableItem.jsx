import React from 'react';
import {useSortable} from '@dnd-kit/sortable';
import {CSS} from '@dnd-kit/utilities';

function SortableItem(props) {
  const {
    attributes,
    listeners,
    setNodeRef,
    transform,
    transition,
  } = useSortable({id: props.tmsId});

  const style = {
    transform: CSS.Transform.toString(transform),
    transition,
  };

  console.log(props)
  return (
    <div ref={setNodeRef} style={style} {...attributes} {...listeners}>
      <img src={props.preferredImage.uri} />
      <p>{props.title}</p>
    </div>
  );
}

export default SortableItem;
