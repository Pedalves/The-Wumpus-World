using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;
using UnityEngine.SceneManagement;

public class GM : MonoBehaviour
{
    public GameObject GameOverText;

    [SerializeField]
    private bool _gameRunning;

    static private GM _instance;

    private void Awake()
    {
        if(_instance)
        {
            Destroy(gameObject);
        }
        else
        {
            _instance = this;
        }
    }

    // Use this for initialization
    void Start ()
    {
        _gameRunning = true;	
	}

    static public GM GetInstance()
    {
        return _instance;
    }

    static public GameObject GetAgent()
    {
        return GameObject.FindGameObjectWithTag("Agent");
    }

    static public bool GetGameRunning()
    {
        return GetInstance()._gameRunning;
    }

    static public void SetGameRunning(bool running)
    {
        GetInstance()._gameRunning = running;

        if(!running)
        {
            GetInstance().GameOverText.SetActive(true);
            GetInstance().GameOverText.GetComponent<Text>().text = "Game Over\nPoints: " + GM.GetAgent().GetComponent<Agent>().Points;
            GetInstance().StartCoroutine(GetInstance().Restart());
        }
    }

    IEnumerator Restart()
    {
        yield return new WaitForSeconds(3);
        SceneManager.LoadScene(SceneManager.GetActiveScene().name);
    }
}
