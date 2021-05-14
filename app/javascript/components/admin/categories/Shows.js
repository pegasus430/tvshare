import React, { useState, useEffect } from "react";
import ReactDOM from "react-dom";
import { DragDropContext, Droppable, Draggable } from "react-beautiful-dnd";
import ShowSearch from "./ShowSearch";
import { Empty, Divider, Input, Switch, Button, message } from 'antd';

const grid = 8;
const reorder = (list, startIndex, endIndex) => {
  const result = Array.from(list);
  const [removed] = result.splice(startIndex, 1);
  result.splice(endIndex, 0, removed);

  return result;
};

const ShowItem = () => {
  return <div style={{background: '#fff', margin: 20, minHeight: 500}}></div>;
  }

  function ShowApp({ category, onDelete }) {
    const [shows, setShows] = useState([]);
    const [draftTitle, setDraftTitle] = useState(category.title || '');
    const [draftActive, setDraftActive] = useState(!!category.active);

    function getShows() {
      return fetch(`/categories/${category.id}.json`)
      .then(data => data.json())
    }

    useEffect(() => {
      let mounted = true;
      getShows()
      .then(data => {
        if(mounted) {
          setShows(data.shows)
        }
      })
      return () => mounted = false;
    }, [category])

    useEffect(() => {
      setDraftTitle(category.title);
      setDraftActive(category.active);
    }, [category])


    function Show({ show, index }) {
      return (
        <Draggable draggableId={show.tmsId} index={index} style={{userSelect: 'none'}}>
          {provided => (
            <div
              style={{display: 'flex', overflow: 'auto', flexDirection: 'row', alignItems: 'flex-start' }}
              ref={provided.innerRef}
              {...provided.draggableProps}
              {...provided.dragHandleProps}
              >
              <div style={{background: '#fff', padding: 20, marginRight: 20, minHeight: 480, width: 280 }}>
                <img src={show.preferredImage ? show.preferredImage.uri : show.preferred_image_uri} style={{marginBottom: 10, maxWidth: '100%'}}/>
                <p>{show.title}</p>
                <Button ghost type="danger" onClick={()=> {setShows(shows.filter((_show) => _show.tmsId !== show.tmsId)) }}>Remove</Button>

              </div>
            </div>
          )}
        </Draggable>
      );
    }
    const ShowList = React.memo(function ShowList({ shows }) {
      return shows.map((show, index) => (React.createElement(Show, { show: show, index: index, key: show.tmsId })));
    });

    const onDragEnd = (result) => {
      if (!result.destination) {
        return;
      }

      if (result.destination.index === result.source.index) {
        return;
      }

      setShows(reorder(
        shows,
        result.source.index,
        result.destination.index
      ));
    }

    const saveShows = () => {
      let data = {
        category: {...category, title: draftTitle, active: draftActive },
        tmsIds: shows.map((show) => show.tmsId),
      }
      const url = `/admin/categories/${category.id}`;

      fetch(url, {
        method: 'PUT',
        headers: {
          'Content-Type': 'application/json'
        },
        body: JSON.stringify(data)
      }).then(response => response.json())
      .then(data => {
        message.info("Category has been saved")
      });
    }

    const deleteCategory = () => {
      const url = `/admin/categories/${category.id}`;

      fetch(url, {
        method: 'Delete',
        headers: {
          'Content-Type': 'application/json'
        },
      }).then(response => {
        message.info("Category has been deleted")
        if (onDelete) {
          onDelete();
        }
      });
    }

    return (
      <div>

        <div>
          <div>
            <Divider>Category Details</Divider>
            <div style={{display: 'flex', justifyContent: 'space-between', width: 500, margin: '0 auto'}}>

              <label><Input value={draftTitle} onChange={(e) => setDraftTitle(e.target.value) } style={{width: 'auto'} }/></label>
              <label>Active <Switch checked={draftActive} onChange={(checked) => setDraftActive(checked) } /></label>

              <Button type="primary" onClick={() => saveShows()}>Save</Button>
            </div>
          </div>


          <div>
            <Divider>Shows</Divider>
          {
            shows.length ?
              <DragDropContext onDragEnd={onDragEnd}>
                <Droppable droppableId="list" direction="horizontal">
                  {provided => (
                    <div ref={provided.innerRef} {...provided.droppableProps} style={{display: 'flex', overflow: 'auto' }}>
                      <ShowList shows={shows} />
                    </div>
                  )}
                </Droppable>
              </DragDropContext> :
              <Empty/>
          }
        </div>

          <div style={{width: '100%'}}>
            <Divider>Add Show</Divider>
            <ShowSearch onClick={(row) => setShows(shows.concat(row)) }/>
          </div>
        </div>

        <Button type="danger" style={{marginTop: "2em"}} onClick={() => confirm('Are you sure you want to delete this category?') && deleteCategory()}>Delete Category</Button>
      </div>
    );
  }

  export default ShowApp;
