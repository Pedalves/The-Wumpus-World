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

    private GameObject[,] _map;
    private GameObject _agent;

    // Use this for initialization
    void Start()
    {
        _map = new GameObject[Width, Height];

        GenerateMap();
        SpawnAgent();
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

    public GameObject GetCell(int i, int j)
    {
        if(i >= Width || i <= 0 || j >= Height || j <= 0)
        {
            return null;
        }
        return _map[i, j];
    }
}
