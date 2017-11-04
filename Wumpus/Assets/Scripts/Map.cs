using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Map : MonoBehaviour
{
    public int Width;
    public int Height;
    public float Size;
    public GameObject Cell;
    public GameObject AgentPrefab;
    public GameObject[] ElementsPrefabs;

    private GameObject[,] _map;
    private GameObject _agent;

    // Use this for initialization
    void Start()
    {
        _map = new GameObject[Width, Height];

        GenerateMap();
        SpawnAgent();
        SpawnElements();
    }

    void GenerateMap()
    {
        for(int i = 0; i < Width; i++)
        {
            for(int j = 0; j < Height; j++)
            {
                GameObject go = Instantiate(Cell, transform.position, Cell.transform.rotation, transform);
                go.transform.position += i * Vector3.right * Size;
                go.transform.position += j * Vector3.forward * Size;
                go.GetComponent<Cell>().Pos = new Vector2(i, j);
                _map[i, j] = go;
            }
        }
    }

    void SpawnAgent()
    {
        if(!_agent)
        {
            _agent = Instantiate(AgentPrefab, _map[0, 0].transform.position, AgentPrefab.transform.rotation);
            _agent.GetComponent<Agent>().MapObj = gameObject;
            _agent.GetComponent<Agent>().CurrentCell = _map[0, 0];
        }
    }

    void SpawnElements()
    {
        for(int i = 0; i < ElementsPrefabs.Length; i++)
        {
            GameObject tmpCell = GetFreeCell();
            Instantiate(ElementsPrefabs[i], tmpCell.transform.position, AgentPrefab.transform.rotation, tmpCell.transform);
            if(ElementsPrefabs[i].CompareTag("Wumpus"))
            {
                foreach(Cell c in GetCellNeighbours(tmpCell.GetComponent<Cell>()))
                {
                    c.gameObject.AddComponent(typeof(Smell));
                }
            }
            else if (ElementsPrefabs[i].CompareTag("Obstacle"))
            {
                foreach (Cell c in GetCellNeighbours(tmpCell.GetComponent<Cell>()))
                {
                    c.gameObject.AddComponent(typeof(Breeze));
                }
            }
        }
    }

    List<Cell> GetCellNeighbours(Cell cell)
    {
        List<Cell> neighbours = new List<Cell>();

        Cell tmpCell = GetCell((int)cell.Pos.x, (int)cell.Pos.y + 1);
        if(tmpCell)
        {
            neighbours.Add(tmpCell);
        }

        tmpCell = GetCell((int)cell.Pos.x, (int)cell.Pos.y - 1);
        if (tmpCell)
        {
            neighbours.Add(tmpCell);
        }

        tmpCell = GetCell((int)cell.Pos.x + 1, (int)cell.Pos.y);
        if (tmpCell)
        {
            neighbours.Add(tmpCell);
        }

        tmpCell = GetCell((int)cell.Pos.x - 1, (int)cell.Pos.y);
        if (tmpCell)
        {
            neighbours.Add(tmpCell);
        }

        return neighbours;
    }

    GameObject GetFreeCell()
    {
        int i, j;

        do
        {
            i = Random.Range(1, Width);
            j = Random.Range(1, Height);
        } while (_map[i, j].transform.childCount > 0);

        return _map[i, j];
    }

    public Cell GetCell(int i, int j)
    {
        if(i >= Width || i < 0 || j >= Height || j < 0)
        {
            return null;
        }
        return _map[i, j].GetComponent<Cell>();
    }
}
